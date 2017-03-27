# fluent-plugin-jvm

[jolokia](https://jolokia.org/) input plugin

## Installation


```ruby
gem 'fluent-plugin-jvm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-jvm

## Configuration

### sample configuration

```conf
    <source>
      type jvm
      tag jvm.memory
      url http://127.0.0.1:8778/jolokia
      mbean java.lang:type=Memory
      attribute HeapMemoryUsage
      interval 60
    </source>
```

### output json sample

```json
{
  "init": 268435456,
  "committed": 234881024,
  "max": 234881024,
  "used": 66044336
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fluent-plugin-jvm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
```
   Copyright 2017 Tokyo Home Security Operation Center

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```