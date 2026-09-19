# 0.7.0

Runs on current Ruby.

* Sinatra moves from 2.x to 4.x and Rack from 2.x to 3.x. Sinatra 2 requires
  ostruct, which left the standard library, so the gem could not even be loaded
  on Ruby 4.
* JSON request bodies, which the README documents as the way to use this API,
  returned 500 on Ruby 4. rack-contrib parses them by calling JSON.parse with
  create_additions, a keyword json 3 removed, and Ruby 4 ships json 3. The app
  now supplies its own parser to the middleware.
* thin and rack-token_auth are no longer dependencies. The README always said
  the deployer brings their own server and auth middleware, and the library
  never required either.
* Requires Ruby 3.2 or newer.
* The published gem no longer carries the Rakefile, Gemfile, CI config or
  development scripts.
* The example config.ru returned a bare string where Rack needs a status,
  headers and body, and used `use` where it needed `map`.

# 0.6.0

Bumping dependencies

# 0.5.0

Bumping dependencies


# 0.4.0

Features:

* Introduced `PUT /builds/:build_id/nodes/:node_id` which enables CI scripts that update node values for instance when rebuilding.

# 0.3.0

Features:

* Clear state for a build using `DELETE /builds/:build_id`. Useful when a CI build is restarted.

Bug fixes:

* Posting now adheres to standard REST conventions; returns 201 with no body if successful and 409 if the node already exists.


# 0.2.0

Features:

* Build ids and node ids may now contain any (url-escaped) character.
   - Note that when all nodes of a build are queried, `GET /builds/:build_id`, node ids will appear in their url-unescaped form.
