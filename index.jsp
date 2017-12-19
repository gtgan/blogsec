<%@ include file="top.jsp" %>
        <title>BlogSec</title>
    </head>
<c:if test="${param.out != null}"><% session.removeAttribute("loginUser"); %></c:if>
<%@ include file="nav.jsp" %>
        <h1>Welcome to BlogSec.</h1><hr/>
        <div style="width:110px">
            <h2>Get started:</h2>
            <a href="blog.jsp"><button style="width:100%;"><h3>Posts</h3></button></a>
            <c:if test="${empty sessionScope['loginUser']}">
            <br/><a href="login.jsp"><button style="width:100%;"><h3>Log In</h3></button></a>
            <br/><a href="signup.jsp"><button style="width:100%;"><h3>Sign Up</h3></button></a>
            </c:if>
        </div>
<%@ include file="bottom.html" %>
