<%@ include file="top.jsp" %>
        <title>BlogSec</title>
    </head>
<c:if test="${param.out != null}"><% session.removeAttribute("loginUser"); %></c:if>
<%@ include file="nav.jsp" %>
        <h1>Welcome to BlogSec.</h1><hr/>
        <p>Where did the name come from?</p>
<%@ include file="bottom.html" %>
