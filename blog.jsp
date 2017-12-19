<%@ include file="top.jsp" %>
<c:if test="${not empty param.del_id}">
    <sql:query dataSource="jdbc/blogsec" var="rp">
        SELECT COUNT(*) AS c FROM Users WHERE email = ? AND pwd_hash = SHA2(CONCAT(?, salt), 512) AND privilege != 'none';
        <sql:param value="${sessionScope['loginUser']}"/>
        <sql:param value="${param.confirm}"/>
    </sql:query>
    <c:choose>
        <c:when test="${rp.rows[0].c eq 0}">
<script>alert("Failed to delete post");</script>
        </c:when>
        <c:otherwise>
            <sql:transaction dataSource="jdbc/blogsec">
                <sql:update var="rd">
                    DELETE FROM Replies where post_id = ?;
                    <sql:param value="${param.del_id}"/>
                </sql:update>
                <sql:update var="rd">
                    DELETE FROM Posts where post_id = ?;
                    <sql:param value="${param.del_id}"/>
                </sql:update>
            </sql:transaction>
        </c:otherwise>
    </c:choose>
</c:if>
        <title>BlogSec |
    <c:choose>
        <c:when test="${empty param.id}">
            Blog Posts
            <sql:query dataSource="jdbc/blogsec" var="result">
                SELECT post_id, title, email, first_name, last_name, modified FROM Posts NATURAL JOIN Users ORDER BY post_id DESC;
            </sql:query>
        </c:when>
        <c:otherwise>
            <sql:query dataSource="jdbc/blogsec" var="result">
                SELECT title, email, first_name, last_name, content, modified FROM Posts NATURAL JOIN Users WHERE post_id = ?;
                <sql:param value="${param.id}"/>
            </sql:query>
            <c:forEach var="r" items="${result.rows}"><c:out value="${r.title} by ${r.first_name} ${r.last_name}"/></c:forEach>
        </c:otherwise>
    </c:choose>
        </title>
    </head>
<%@ include file="nav.jsp" %>
<%@ include file="privilege.jsp" %>
<c:choose>
    <c:when test="${empty param.id}">
        <h1>Posts</h1><hr/>
        <c:if test="${privilege eq 'admin' || privilege eq 'user'}"><a href="newpost.jsp">New post</a></c:if>
        <table width="100%">
            <thead><tr>
                <th style="width:72px;"></th>
                <th>Title</th>
                <th>By</th>
                <th>Modified</th>
            </tr></thead>
            <tbody>
                <c:forEach var="r" items="${result.rows}"><tr style="height:18px;">
                    <td><c:if test="${privilege eq 'admin' || r.email eq sessionScope['loginUser']}">
                        <button type="button" id="s${r.post_id}" onclick="document.getElementById('del${r.post_id}').style.display='block'; document.getElementById('s${r.post_id}').style.display='none';">Delete</button>
                        <form id="del${r.post_id}" name="delete${r.post_id}" method="post" style="display:none;">
                            Enter your password to confirm:<br/>
                            <input id="confirm${r.post_id}" name="confirm" type="password" placeholder="Enter your password to confirm"/><br/>
                            <input type="submit" value="Delete"/><input type="hidden" name="del_id" value="${r.post_id}"/>
                            <button type="button" onclick="document.getElementById('del${r.post_id}').style.display='none'; document.getElementById('s${r.post_id}').style.display='block';">Cancel</button>
                        </form>
                    </c:if></td>
                    <td><a href="blog.jsp?id=<c:out value='${r.post_id}'/>"><b><c:out value="${r.title}"/></b></a></td>
                    <c:set var="uname" value="${r.first_name} ${r.last_name}"/>
                    <c:if test="${uname eq ' '}"><c:set var="uname" value="${r.email}"/></c:if>
                    <td><a href="users.jsp?mail=${r.email}"><c:out value="${r.first_name} ${r.last_name}"/></a></td>
                    <td><c:out value="${r.modified}"/></td>
                </tr></c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise><c:forEach var="r" items="${result.rows}">
        <div>
            <h1><c:out value="${r.title}"/></h1>
            <h3><c:out value="${r.first_name} ${r.last_name}"/></h3><hr/>
            <p><c:out value="${r.content}"/></p><!-- will support markdown eventually -->
            <p style="text-align:right;">
                <c:if test="${r.email eq sessionScope['loginUser'] || privilege eq 'admin'}">
                    <form name="delete" method="post">
                        <!-- edit/delete -->
                    </form>
                </c:if>
                <i>Modified <c:out value="${r.modified}"/></i>
            </p>
            <hr/>
            <c:if test="${userPrivilege eq 'true'}">
                <c:if test="${not empty param.replyText}">
                    <sql:update dataSource="jdbc/blogsec" var="res">
                        INSERT INTO Replies (email, post_id, content) VALUES (?, ?, ?);
                        <sql:param value="${sessionScope['loginUser']}"/>
                        <sql:param value="${param.id}"/>
                        <sql:param value="${param.replyText}"/>
                    </sql:update>
                </c:if>
            <form id="replyForm" method="post">
                <input name="replyText" type="text" placeholder="Reply"></textarea>
                <input type="submit" value="Reply"/>
            </form>
            </c:if>
        </div>
        <sql:query dataSource="jdbc/blogsec" var="replies">
            SELECT first_name, last_name, content, modified FROM Replies NATURAL JOIN Users WHERE post_id = ? ORDER BY created;
            <sql:param value="${param.id}"/>
        </sql:query>
        <c:forEach var="re" items="${replies.rows}"><div>
            <p><c:out value="${re.content}"/></p>
            <p style="text-align:right;"><i>- <c:out value="${re.first_name} ${re.last_name}, ${re.modified}"/></i></p>
        </div></c:forEach>
    </c:forEach></c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
