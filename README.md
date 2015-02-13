## This is my personal rockbox tagnavi config

For more info consult the [rockbox wiki](http://www.rockbox.org/wiki/DataBase#tagnavi.config_v2.0_Syntax)

### Notes:

#### Why Makefiles, wtf??

Well, it turns out `%include` instructions can't be used exessively like I
would need to with my config.

#### Regarding PATHFILTER

It's a little dirty hack to allow me to add a `filename ^ "<path>"` condition
to all filters.

### TODO:

- Use [Rake](https://github.com/ruby/rake) instead of make
- Syntax checks(?)
- Wrap the whole thing in ruby dsl

### LICENSE:

<a href="http://www.wtfpl.net/">
  <img src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png" width="80" height="15" alt="WTFPL" />
</a>

See [LICENSE](LICENSE) for more info.
