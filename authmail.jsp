<%@ include file="top.jsp" %>
        <title>BlogSec | Sign Up</title>
    </head>
<%@ include file="nav.jsp" %>
<%@ include file="privilege.jsp" %>
<c:if test="${userPrivilege || empty sessionScope['loginUser']}"><c:redirect url="index.jsp"/></c:if>
        <h1>Account Verification</h1><hr/>
        You should receive an email with a sixteen-character verification code. Enter it here.
        <form method="post">
            <input type="password" name="authcode" default="Verification code" required="t" minlength="16" maxlength="16"/>
            <input type="submit" value="Verify"/>
        </form>
        The email may take some time to arrive. If it takes longer than a minute, try resending it.
<c:if test="${not empty param.authcode}">
    <sql:update dataSource="jdbc/blogsec" var="n">
        UPDATE Users SET privilege = 'user' WHERE EXISTS (SELECT * FROM AuthCodes WHERE AuthCodes.email = Users.email AND Users.email = ? AND code_hash = SHA(CONCAT(?, code_salt), 512)));
        <sql:param value="${sessionScope['loginUser']}"/>
        <sql:param value="${param.authcode}"/>
    </sql:update>
    <c:choose>
        <c:when test="${n eq 0}"><c:redirect url="index.jsp"/></c:when>
        <c:otherwise><script>
            alert("Verification failed");
        </script></c:otherwise>
    </c:choose>
</c:if>
<%@ include file="bottom.html" %>
