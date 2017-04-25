# 0.3.0

Features:

* Clear state for a build using `DELETE /builds/:build_id`. Useful when a CI build is restarted.

Bug fixes:

* Posting now adheres to standard REST conventions; returns 201 with no body if successful and 409 if the node already exists.


# 0.2.0

Features:

* Build ids and node ids may now contain any (url-escaped) character.
   - Note that when all nodes of a build are queried, `GET /builds/:build_id`, node ids will appear in their url-unescaped form.
