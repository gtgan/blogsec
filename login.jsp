<%@ include file="top.jsp" %>
        <title>BlogSec | Sign Up</title>
    </head>
<%@ include file="nav.jsp" %>
<c:choose>
    <c:when test="${empty param.mail}">
        <h1>Log In</h1><hr/>
        <form method="POST" action="login.jsp">
            Email<br/><input type="email" name="mail" placeholder="Email address" maxlength="255" required="t"/><br/>
            Password<br/><input type="password" name="pwd" placeholder="Password" minlength="8" maxlength="255" required="t"/><br/>
            <input type="submit" value="Log in"/>
        </form>
    </c:when>
    <c:otherwise>
        <sql:query dataSource="jdbc/blogsec" var="result">
            SELECT count(*) AS ct FROM Users WHERE email = ? AND pwd_hash = SHA2(CONCAT(?, salt), 512);
            <sql:param value="${param.mail}"/>
            <sql:param value="${param.pwd}"/>
        </sql:query>
        <c:forEach var="row" items="${result.rows}">
            <c:choose>
                <c:when test="${row.ct gt 0}">
                    <c:set scope="session" var="loginUser" value="${param.mail}"/>
                    <c:redirect url="index.jsp"/>
                </c:when>
                <c:otherwise><script>alert("Login information is incorrect.");</script></c:otherwise>
            </c:choose>
        </c:forEach>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
