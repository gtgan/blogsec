    <body>
        <nav>
            <a href="index.jsp"><h3 style="display:inline;">BlogSec</h3></a>
            <span style="float:right;">
                <a href="blog.jsp">Blog Posts</a> |
            <c:choose><c:when test="${empty sessionScope['loginUser']}">
                <a href="signup.jsp">Sign Up</a> |
                <a href="login.jsp">Log In</a>
            </c:when><c:otherwise>
                <c:out value="${sessionScope['loginUser']}"/> |
                <a href="index.jsp?out=t">Log Out</a>
            </c:otherwise></c:choose>
            </span>
        </nav>
