<%@ include file="top.jsp" %>
        <title>BlogSec | Sign Up</title>
    </head>
<%@ include file="nav.jsp" %>
<c:choose>
    <c:when test="${empty param.mail}">
        <h1>Sign Up</h1><hr/>
        <form method="POST" action="login.jsp">
            Email<br/><input type="email" name="mail" placeholder="Email address" maxlength="255" required="t"/><br/>
            Password<br/><input type="password" name="pwd" placeholder="Password" minlength="8" maxlength="255" required="t"/><br/>
            <input type="submit" value="Log in"/>
        </form>
    </c:when>
    <c:otherwise>
        <sql:query dataSource="jdbc/BSDB" var="result">
            SELECT FROM Users WHERE email = ? AND pwd_hash = SHA2(CONCAT(?, salt), 512);
            <sql:param value="${param.mail}"/>
            <sql:param value="${param.pwd}"/>
        </sql:query>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
