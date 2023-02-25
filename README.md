# cancancan-js
CanCanCan, But Accessible in the Front-End Javascript
- uses CanCanCan Library: https://github.com/CanCanCommunity/cancancan

# Config
require 'cancancan_js'

Add this to your class Ability:
`include CanCanCanExport`

Add to your javascript application.js file:
`//= require cancancan_js`

# Implementation
## Back-end
We need to export the Ability rules to your front-end from your back-end. There are several ways to do this.
- Add a new method to your user model
  - Add that method to a JSON serializer, export that user to the front-end
- Create a new action/route on your users controller.
  - Use that action to call `current_ability.export` or `Ability.export(current_user)`

## Front-end
After you are able to pull the back-end cancancan export to the front-end, you then call this method and pass it the cancancan export:
`set_abilities(<export_rules>)`

# Usage
You can now call the JS function `can`, and pass it similar CanCanCan values
ex: `can('show', 'User')`
ex: `can('show', 'User', {id: 1, email: "test_email", name: "John Johnson"})`
You can also check against allow-listed attribs (that you would have set up in CanCanCan)
ex: `can('update', 'User', {id: 1, email: "test_email", name: "John Johnson"}, 'email')`

# Usage (AngularJS)
Create a new function in AngularJS, to pass the attributes onto the JS function
`
$scope.can = function(action, class_name, object, column, options) {
  return can(action, class_name, object, column, options)
}
`
You can now use it in angular HTML with angular objects
`ng-show="can('update', resource_class, resource_instance)`
