<%@ include file="privilege.jsp" %>
    <body>
        <nav>
            <a href="index.jsp"><h3 style="display:inline;">BlogSec</h3></a>
            <span style="float:right;">
                <a href="blog.jsp">Blog Posts</a> |
            <c:choose><c:when test="${empty sessionScope['loginUser']}">
                <a href="signup.jsp">Sign Up</a> |
                <a href="login.jsp">Log In</a>
            </c:when><c:otherwise>
                <a href="users.jsp?mail=${sessionScope['loginUser']}"><c:out value="${sessionScope['loginUser']}"/></a> |
                <c:if test="${not userPrivilege}"><a href="authmail.jsp">Verify account</a> |</c:if>
                <a href="hack.jsp">Hack</a> |
                <a href="index.jsp?out=t">Log Out</a>
            </c:otherwise></c:choose>
            </span>
        </nav>
