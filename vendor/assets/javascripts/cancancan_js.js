var _abilities = _abilities === undefined ? {} : _abilities

var set_abilities = function(abilities) {
  _abilities = abilities
}

// Attempting to Mirror CanCan's rails' helper method.
// action:             matched against cancan actions. ex: read, show, index, update, create, destroy, or custom method.
// class_name:         self descriptive, any of your model class names.
// object (optional):  a hash representation of the object. Used to compare attribs against cancan conditionals
// column (optional):  a specific attribute to see if it's white-listed within cancan's conditionals.
// options (optional): options hash
var can = function(action, class_name, object, column, options) {
  if (options === undefined) {
    options = {}
  }
  var verbose = options['verbose'] === true

  if (_abilities === undefined || Object.keys(_abilities).length === 0) {
    if (verbose) {
      console.log("cancancan-js Error! `_abilities` variable not defined or not populated")
    }
    return false
  }

  if (object === undefined) {
    // Class check
    if (isInArray(_abilities['class_abilities']['manage'], 'all')) {
      return true;
    } else if (action == "read" && isInArray(_abilities['class_abilities']['read'], 'all') ) {
      return true;
    } else if (action == "show" && isInArray(_abilities['class_abilities']['read'], 'all') ) {
      return true;
    } else if (action == "show" && isInArray(_abilities['class_abilities']['show'], 'all') ) {
      return true;
    } else if (action == "index" && isInArray(_abilities['class_abilities']['read'], 'all') ) {
      return true;
    } else if (action == "index" && isInArray(_abilities['class_abilities']['index'], 'all') ) {
      return true;
    } else if (_abilities['class_abilities'][action] && isInArray(_abilities['class_abilities'][action], class_name)) {
      return true;
    } else {
      return false;
    }
  } else {
    // Object specific check
    if (isInArray(_abilities['class_abilities']['manage'], 'all')) {
      return true;
    } else if (action == "read" && isInArray(_abilities['class_abilities']['read'], 'all') ) {
      return true;
    } else if (action == "show" && isInArray(_abilities['class_abilities']['read'], 'all') ) {
      return true;
    } else if (action == "show" && isInArray(_abilities['class_abilities']['show'], 'all') ) {
      return true;
    } else if (action == "index" && isInArray(_abilities['class_abilities']['read'], 'all') ) {
      return true;
    } else if (action == "index" && isInArray(_abilities['class_abilities']['index'], 'all') ) {
      return true;
    } else {

      var object_rules = _abilities['object_rules'];

      if (object_rules[class_name] && object_rules[class_name][action]) {
        var found_whole_valid_group_of_conditions = false
        var valid_column_non_applicable_or_access = false
        if (object_rules[class_name][action]['condition_groups']) {
          found_whole_valid_group_of_conditions = checkCanConditionalGroups(object, object_rules[class_name][action]['condition_groups'], verbose)
        } else {
          // Condition group was nil, meaning that we can perform action without filter.
          found_whole_valid_group_of_conditions = true;
        }

        if (column && object_rules[class_name][action]['whitelist_attribs']) {
          valid_column_non_applicable_or_access = isInArray(object_rules[class_name][action]['whitelist_attribs'], column)
        } else {
          valid_column_non_applicable_or_access = true
        }

        return found_whole_valid_group_of_conditions && valid_column_non_applicable_or_access
      } else {
        //  Invalid permissions
        return false;
      }

      // Safety catch-all, but should not be reached
      if (verbose) {
        console.log("cancancan-js Error! Should not have reached tail-end of 'can' function")
      }
      return false
    }
  }
}


function valueIsInArray(array, expected_value) {
  // console.log("valueIsInArray")
  found_value = false;
  if (array) {
    $.each( array, function( index, value ){
      if (value == expected_value) {
          found_value = true;
      }
    });
  }
  return found_value;
}

function isInArray(array, element) {
  if (array === undefined) {
    return false;
  } else if (Array.isArray(array)) {
    return ($.inArray(element, array) >= 0);
  } else if (typeof(array) == "object") {
    return array.hasOwnProperty(element)
  } else {
    throw "cancancan-js - Unsupported Array element type: " + typeof(array)
  }
}

// Check group of 'can' conditionals
// - recursive
function checkCanConditionalGroups(object, condition_groups, verbose) {
  if (verbose) {
    console.log("cancancan-js - checkCanConditionalGroups - incoming params")
    console.log(object)
    console.log(condition_groups)
  }
  var found_whole_valid_group_of_conditions = false
  // Iterating through each group of conditions, a whole grouping has to match in order to be successful
  $.each(condition_groups, function( index, conditions ) {
    var valid_condition_for_group = false
    if (verbose) {
      console.log("cancancan-js - Checking condition group: " + index)
      console.log(conditions)
    }
    valid_condition_for_group = checkCanConditionals(object, conditions, verbose);
    if (valid_condition_for_group) {
      found_whole_valid_group_of_conditions = true
      return false
    }
  });

  return found_whole_valid_group_of_conditions;
}

// Check 'can' conditionals array
// - recursive
function checkCanConditionals(object, conditions, verbose) {
  if (verbose) {
    console.log("cancancan-js - checkCanConditionals - incoming params")
    console.log(object)
    console.log(conditions)
  }
  var found_invalid_condition = false
  // Every conditions has to be true, in order to be authable.
  $.each(conditions, function(assocation_name, expected_value) {
    valid_condition_for_group = true
    if (verbose) {
      console.log("cancancan-js - ASSOCIATION NAME: " + assocation_name + ", EXPECTED VALUE: " + expected_value)
    }
    if (typeof(expected_value) === 'string' || typeof(expected_value) === 'number' || typeof(expected_value) === 'boolean' || expected_value == null) {
      if (verbose) {
        console.log("cancancan-js - STRING, NUMBER, BOOLEAN, OR NULL TYPE EXPECTED")
      }
      valid_condition = object[assocation_name] == expected_value
      if (verbose) {
        console.log("cancancan-js - Simple Object comparison:")
      }
    } else if (Array.isArray(expected_value)) {
      if (verbose) {
        console.log("cancancan-js - ARRAY TYPE EXPECTED")
      }
      if (object[assocation_name] && Array.isArray(object[assocation_name])) {
        if (verbose) {
          console.log("cancancan-js - Array to Array comparison")
        }
        var found_invalid_object = false

        $.each(object[assocation_name], function(index, value_in_object_array) {
          if ( !valueIsInArray(expected_value, value_in_object_array) ) {
            found_invalid_object = true
          }
        })
        if (found_invalid_object) {
          valid_condition = false
        }

      } else {
        if (verbose) {
          console.log("cancancan-js - Array to simple value comparison")
          console.log(object[assocation_name])
          console.log(expected_value)
        }
        valid_condition = valueIsInArray(expected_value, object[assocation_name]);
      }
    } else {
      if (verbose) {
        console.log("cancancan-js - HASH TYPE, NEED ASSOCIATION PRESENT ON OBJECT")
      }
      // expected_value is another hash. Using recursion.
      if (object[assocation_name] === undefined || object[assocation_name] === null) {
        // If association is not present on object, then can't run any conditionals on it.
        if (verbose) {
          console.log("cancancan-js - Object's association was undefined.")
        }
        valid_condition = false; 
      } else {
        // If association is not present on object, then can't run any conditionals on it.
        if (verbose) {
          console.log("cancancan-js - Object's association is nested, start recursion.")
        }
        if (Array.isArray(object[assocation_name])) {
          var all_match = true
          $.each(object[assocation_name], function(index, value_in_object_array) {
            if (!checkCanConditionals(value_in_object_array, expected_value, verbose)) {
              all_match = false
            }
          })
          valid_condition = all_match
        } else {
          valid_condition = checkCanConditionals(object[assocation_name], expected_value, verbose);
        }
        if (verbose) {
          console.log("cancancan-js - Object's association was nested, end recursion.")
        }
      }
    }
    if (verbose) {
      console.log("cancancan-js - assocation_name: " + assocation_name + ", with value: ")
      console.log(expected_value)
      console.log("cancancan-js - Againt object's")
      console.log(object[assocation_name])
      console.log("cancancan-js - was: " + valid_condition)
    }
    if (!valid_condition) {
      found_invalid_condition = true
      return false;
    }
  });

  return !found_invalid_condition;
}
