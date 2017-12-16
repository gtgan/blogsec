<%@ page import="java.security.*" %>
<%@ include file="top.jsp" %>
<%! private static SecureRandom rng = new SecureRandom();
    private byte[] salt = new byte[128]; %>
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
        <sql:update dataSource="jdbc/BSDB" var="up">
            INSERT INTO Users (email, first_name, last_name, salt, pwd_hash) VALUES (?, ?, ?, ?, SHA2(CONCAT(?, salt), 512));
            <sql:param value="${param.mail}"/>
            <sql:param value="${param.fname}"/>
            <sql:param value="${param.lname}"/>
            <sql:param value="${salt}"/>
            <sql:param value="${param.pwd}"/>
        </sql:update>
        <c:redirect url="index.jsp"/>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
