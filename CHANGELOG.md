# 0.2.0

Features:

* Build ids and node ids may now contain any (url-escaped) character.
   - Note that when all nodes of a build are queried, `GET /builds/:build_id`, node ids will appear in their url-unescaped form.
