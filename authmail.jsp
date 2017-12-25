<%@ page import="java.security.*,javax.mail.*,javax.mail.internet.*,javax.activation.*" %>
<%! private static SecureRandom rng = new SecureRandom();
    private static final byte[] CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".getBytes(); %>
<%@ include file="top.jsp" %>
<c:if test="${privilege not eq 'none'}"><c:redirect url="index.jsp"/></c:if>
        <title>BlogSec | Sign Up</title>
    </head>
<c:if test="${not empty param.resend}">
<% byte[] authcode = new byte[16];
   for (int i = 0; i < authcode.length; i ++) authcode[i] = CHARS[rng.nextInt(62)];
   Properties props = System.getProperties();
   props.setProperty("mail.smtp.host", "localhost");
   Session mSession = Session.getDefaultInstance(props);
   try {
       MimeMessage msg = new MimeMessage(mSession);
       msg.setFrom(new InternetAddress("gregtgan.dev@gmail.com"));
       msg.setRecipient(Message.RecipientType.TO, new InternetAddress(session.getAttribute("loginUser").toString()));
       msg.setSubject("BlogSec account verification");
       msg.setText("Your verification code is '"+new String(authcode)+"'. If you didn't create a BlogSec account, you can ignore this message.");
       Transport.send(msg);
   } catch(Exception e) {
       pageContext.setAttribute("mailerr", "t");
   } %>
   <c:choose>
       <c:when test="${empty mailerr}"><script>alert('Email resent.');</script></c:when>
       <c:otherwise><script>alert('Mailing error: host may be unable to send mail.');</script></c:otherwise>
   </c:choose>
</c:if>
<%@ include file="nav.jsp" %>
        <h1>Account Verification</h1><hr/>
        You should receive an email with a sixteen-character verification code. Enter it here.
        <form method="post">
            <input type="password" name="authcode" default="Verification code" required="t" minlength="16" maxlength="16"/>
            <input type="submit" value="Verify"/>
        </form>
        The email may take some time to arrive. If it takes longer than a minute, try resending it.
        <form method="post">
            <input type="hidden" name="resend" value="t"/>
            <input type="submit" value="Resend email"/>
        </form>
<c:if test="${not empty param.authcode}">
    <sql:update dataSource="jdbc/blogsec" var="n">
        UPDATE Users SET privilege = 'user' WHERE EXISTS (SELECT * FROM AuthCodes WHERE AuthCodes.email = Users.email AND Users.email = ? AND code_hash = SHA2(CONCAT(?, code_salt), 512));
        <sql:param value="${sessionScope['loginUser']}"/>
        <sql:param value="${param.authcode}"/>
    </sql:update>
    <c:choose>
        <c:when test="${n gt 0}"><c:redirect url="index.jsp"/></c:when>
        <c:otherwise><script>
            alert("Verification failed");
        </script></c:otherwise>
    </c:choose>
</c:if>
<%@ include file="bottom.html" %>
