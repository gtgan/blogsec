<%@ include file="top.jsp" %>
        <title>BlogSec | New Post</title>
<%@ include file="nav.jsp" %>
<%@ include req_auth.jsp %>
        <h1>New Post</h1><hr/>
<c:choose>
    <c:when test="${empty param.title}">
        <form name="newPost" method="post">
            <input type="text" name="title" placeholder="Title of post" maxlength="255" required="t"/>
            <textarea name="content" style="height:48px;" placeholder="Post content"></textarea>
            <input type="submit" value="Post"/>
        </form>
    </c:when>
    <c:otherwise>
        <sql:transaction>
            <sql:update dataSource="jdbc/blogsec" var="res">
                INSERT INTO Posts (email, title, content) VALUES (?, ?, ?);
                <sql:param value="${sessionScope['loginUser']}"/>
                <sql:param value="${param.title}"/>
                <sql:param value="${param.content}"/>
            </sql:update>
            <sql:query var="nextId">
                SELECT LAST_INSERT_ID() as lastId;
            </sql:query>
        </sql:transaction>
        New post: <a href="blog.jsp?${nextId.rows[0].lastId}"><c:out value="${param.title}"/></a>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
