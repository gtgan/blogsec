<%@ include file="top.jsp" %>
        <title>
            BlogSec
        <c:if test="${not empty param.mail}">
            | <c:out value="${param.mail}"/>
        </c:if>
        </title>
    </head>
<c:if test="${param.out != null}"><% session.removeAttribute("loginUser"); %></c:if>
<%@ include file="nav.jsp" %>
<c:choose>
    <c:when test="${empty param.mail}">
        <h1>Users</h1><hr/>
        <sql:query dataSource="jdbc/blogsec" var="result">
            SELECT email, first_name, last_name, bio, privilege FROM Users ORDER BY privilege DESC;
        </sql:query>
        <table width="100%">
            <thead><tr>
                <th>User</th>
                <th>Bio</th>
                <th>Privilege</th>
            </tr></thead>
            <tbody>
                <c:forEach var="row" items="${result.rows}"><tr>
                    <c:set var="uname" value="${row.first_name} ${row.last_name}"/>
                    <c:if test="${uname eq ' '}"><c:set var="uname" value="${row.email}"/></c:if>
                    <a href="users.jsp?mail=${row.email}"><td><c:out value="${uname}"/></td></a>
                    <td><c:out value="${row.bio}"/></td>
                    <td><c:out value="${row.privilege}"/></td>
                </tr></c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <%@ include file="privilege.jsp" %>
        <c:if test="${not empty param.bio && param.mail eq sessionScope['loginUser']}">
            <sql:update dataSource="jdbc/blogsec" var="r">
                UPDATE Users SET bio = ? WHERE email = ?;
                <sql:param value="${param.bio}"/>
                <sql:param value="${param.mail}"/>
            </sql:update>
        </c:if>
        <sql:query dataSource="jdbc/blogsec" var="uinfo">
            SELECT * FROM Users WHERE email = ?;
            <sql:param value="${param.mail}"/>
        </sql:query>
        <c:forEach var="user" items="${uinfo.rows}"><div>
            <c:set var="uname" value="${user.first_name} ${user.last_name}"/>
            <c:if test="${uname eq ' '}"><c:set var="uname" value="${row.email}"/></c:if>
            <c:set var="mine" value="${user.email eq sessionScope['loginUser'] && not empty user.email}"/>
            <h1><c:out value="${uname}"/></h1><hr/>
            <h3><c:out value="${user.email}"/></h3>
            Privileges: <c:out value="${user.privilege}"/>
            <p><h3>Bio</h3><c:out value="${user.bio}"/></p>
            <c:if test="${mine}"><p>
                <button id="showupbio" onclick="document.getElementById('upbio').style.display='block'; document.getElementById('showupbio').style.display='none';">Edit bio</button>
                <form id="upbio" method="post" style="display:none;">
                    Edit bio<br/><textarea name="bio" id="bio">${user.bio}</textarea><br/>
                    <button type="button" onclick="document.getElementById('showupbio').style.display='block'; document.getElementById('upbio').style.display='none';">Cancel</button>
                    <input type="submit" value="Update"/>
                </form>
            </p></c:if></hr>
            <c:if test="${not empty param.um && (mine || privilege eq 'admin')}">
                <sql:query dataSource="jdbc/blogsec" var="rp">
                    SELECT COUNT(*) AS c FROM Users WHERE email = ? AND pwd_hash = SHA2(CONCAT(?, salt), 512) AND privilege != 'none';
                    <sql:param value="${sessionScope['loginUser']}"/>
                    <sql:param value="${param.confdel}"/>
                </sql:query>
                <c:choose>
                    <c:when test="${rp.rows[0].c eq 0}">
            <script>alert("Failed to delete post");</script>
                    </c:when>
                    <c:otherwise>
                        <sql:transaction dataSource="jdbc/blogsec" var="del">
                            <sql:update var="rd">
                                DELETE FROM Replies where post_id = ?;
                                <sql:param value="${param.del_id}"/>
                            </sql:update>
                            <sql:update var="rp">
                                DELETE FROM Posts WHERE post_id = ? AND email = ?;
                                <sql:param value="${param.del_id}"/>
                                <sql:param value="${param.um}"/>
                            </sql:update>
                        </sql:transaction>
                    </c:otherwise>
                </c:choose>
            </c:if>
            <sql:query dataSource="jdbc/blogsec" var="rp">
                SELECT post_id, title, modified FROM Posts WHERE email = ? ORDER BY post_id DESC;
                <sql:param value="${user.email}"/>
            </sql:query>
            <c:if test="${not empty rp}"><table style="width:100%;">
                <thead><tr>
                    <th style="width:72px;"></th>
                    <th>Title</th>
                    <th>Modified</th>
                </tr></thead>
                <tbody>
                    <c:forEach var="r" items="${rp.rows}"><tr style="height:18px;">
                        <td><c:if test="${privilege eq 'admin' || mine}">
                            <button type="button" id="s${r.post_id}" onclick="document.getElementById('del${r.post_id}').style.display='block'; document.getElementById('s${r.post_id}').style.display='none';">Delete</button>
                            <form id="del${r.post_id}" name="delete${r.post_id}" method="post" style="display:none;">
                                Enter your password to confirm:<br/>
                                <input id="confirm${r.post_id}" name="confdel" type="password" placeholder="Enter your password to confirm"/><br/>
                                <input type="submit" value="Delete"/><input type="hidden" name="del_id" value="${r.post_id}"/>
                                <input type="hidden" name="um" value="${user.email}"/>
                                <button type="button" onclick="document.getElementById('del${r.post_id}').style.display='none'; document.getElementById('s${r.post_id}').style.display='block';">Cancel</button>
                            </form>
                        </c:if></td>
                        <td><a href="blog.jsp?id=<c:out value='${r.post_id}'/>"><b><c:out value="${r.title}"/></b></a></td>
                        <td><c:out value="${r.modified}"/></td>
                    </tr></c:forEach>
                </tbody>
            </table></c:if>
        </div></c:forEach>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
