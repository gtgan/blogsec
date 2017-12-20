<%@ include file="top.jsp" %>
        <title>BlogSec</title>
    </head>
<c:if test="${not empty param.out && not empty sessionScope.loginUser}"><% session.removeAttribute("loginUser"); %></c:if>
<%@ include file="nav.jsp" %>
        <h1>Welcome to BlogSec.</h1><hr/>
        <div style="width:110px">
            <h2>Get started:</h2>
            <a href="blog.jsp"><button style="width:100%;"><h3>Posts</h3></button></a><br/>
            <c:choose>
                <c:when test="${empty sessionScope['loginUser']}">
            <a href="signup.jsp"><button style="width:100%;"><h3>Sign Up</h3></button></a><br/>
            <a href="login.jsp"><button style="width:100%;"><h3>Log In</h3></button></a>
                </c:when>
                <c:otherwise>
            <a href="hack.jsp"><button style="width:100%;"><h3>Hack!</h3></button></a>
                </c:otherwise>
            </c:choose>
        </div>
<%@ include file="bottom.html" %>
