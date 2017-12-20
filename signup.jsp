<%@ page import="java.security.*,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%@ include file="top.jsp" %>
<%! private static SecureRandom rng = new SecureRandom();
    private byte[] salt = new byte[128];
    private final byte[] CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".getBytes(); %>
        <title>BlogSec | Sign Up</title>
    </head>
<%@ include file="nav.jsp" %>
<c:choose>
    <c:when test="${empty param.mail || param.pwd != param.re}">
        <h1>Sign Up</h1><hr/>
        <form method="POST" action="signup.jsp">
            Email*<br/><input type="email" name="mail" placeholder="Email address" maxlength="255" required="t"/><br/>
            Password*<br/><input type="password" name="pwd" placeholder="At least 8 characters" minlength="8" maxlength="255" required="t"/><br/>
            Retype password*<br/><input type="password" name="re" placeholder="Confirm password" minlength="8" maxlength="255" required="t"/><br/>
            First name<br/><input type="text" name="fname" placeholder="First name (optional)" maxlength="255"/><br/>
            Last name<br/><input type="text" name="lname" placeholder="Last name (optional)" maxlength="255"/><br/>
            <input type="submit" value="Sign up"/>
        </form>
        <c:if test="${param.pwd != param.re}">
            <script>alert("Passwords must match");</script>
        </c:if>
    </c:when>
    <c:otherwise>
        <% rng.nextBytes(salt);
           pageContext.setAttribute("salt", salt); %>
        <sql:update dataSource="jdbc/blogsec" var="up">
            INSERT INTO Users (email, first_name, last_name, salt, pwd_hash) VALUES (?, ?, ?, ?, SHA2(CONCAT(?, salt), 512));
            <sql:param value="${param.mail}"/>
            <sql:param value="${param.fname}"/>
            <sql:param value="${param.lname}"/>
            <sql:param value="${salt}"/>
            <sql:param value="${param.pwd}"/>
        </sql:update>
        <% rng.nextBytes(salt);
           pageContext.setAttribute("salt", salt);
           byte[] authcode = new byte[16];
           for (int i = 0; i < authcode.length; i ++) authcode[i] = CHARS[rng.nextInt(62)];
           pageContent.setAttribute("authcode", authcode); %>
        <sql:update dataSource="jdbc/blogsec" var="ac">
            INSERT INTO AuthCodes (email, code_salt, code_hash) VALUES (?, ?, SHA(CONCAT(?, code_salt), 512));
            <sql:param value="${param.mail}"/>
            <sql:param value="${salt}"/>
            <sql:param value="${authcode}"/>
        </sql:update>
        <c:if test="${ac gt 0}">
        <% Properties props = System.getProperties();
           props.setProperty("mail.smtp.host", "localhost");
           Session mSession = Session.getDefaultInstance(properties);
           try {
               MimeMessage msg = new MimeMessage(mSession);
               msg.setFrom(new InternetAddress("noreply.blogsec@54.241.95.167"));
               msg.setRecipient(Message.RecipientType.TO, new InternetAddress(getParameter("mail")))
               msg.setSubject("BlogSec account verification");
               msg.setText("Your verification code is '"+new String(authcode)+"'. If you didn't create a BlogSec account, you can ignore this message.");
               Transport.send(msg);
           } catch(Exception e) {
               pageContent.setAttribute("mailerr", "t");
           } %>
        </c:if>
        <c:choose>
            <c:when test="${empty mailerr}">
                <c:redirect url="authmail.jsp"/>
            </c:when>
            <c:otherwise>
        Mailing error.
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
