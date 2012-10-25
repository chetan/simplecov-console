# simplecov-console

A simple console output formatter for SimpleCov

### Usage

```bash
$ gem install simplecov-console
```

```ruby
SimpleCov.formatter = SimpleCov::Formatter::Console
# or
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
]
```

Example output:
```
COVERAGE:  68.89% -- 910/1321 lines

showing bottom (worst) 15 of 65 files
+----------+----------------------------------------------------+
| coverage | file                                               |
+----------+----------------------------------------------------+
|  16.67%  | lib/bixby/modules/metrics/rescan.rb                |
|  20.93%  | lib/bixby/modules/repository.rb                    |
|  21.43%  | app/controllers/monitoring/commands_controller.rb  |
|  22.73%  | app/controllers/hosts_controller.rb                |
|  22.73%  | app/controllers/monitoring/checks_controller.rb    |
|  25.00%  | lib/rails_ext/migration.rb                         |
|  25.00%  | app/controllers/inventory/hosts_controller.rb      |
|  28.21%  | lib/bixby/modules/monitoring.rb                    |
|  30.00%  | app/controllers/monitoring/metrics_controller.rb   |
|  30.77%  | lib/rails_ext/to_api.rb                            |
|  36.11%  | app/controllers/application_controller.rb          |
|  40.00%  | app/controllers/monitoring/resources_controller.rb |
|  40.00%  | app/controllers/monitoring/hosts_controller.rb     |
|  46.15%  | lib/bixby/modules/notifier.rb                      |
|  47.83%  | lib/bixby/hooks.rb                                 |
+----------+----------------------------------------------------+

URL: file:///.../coverage/index.html
```


### Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2012 Chetan Sarva. See LICENSE.txt for
further details.
