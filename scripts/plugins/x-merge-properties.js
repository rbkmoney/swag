var jpointer = require('json-pointer');
var mergePatch = require('json-merge-patch');

module.exports = {
  pathExpression: '$..["x-merge-properties"]',
  init: function(swagger) {
    console.log('* x-merge-properties plugin');
  },
  process: function(parent, name, jsonpath, swagger) {
    console.log('jsonpath' + jsonpath);

    var value = parent[name];
    if (!Array.isArray(value)) {
      throw Error('x-merge-properties argument should be array at ' + jsonpath);
    }
    let props = {};
    let required = [];
    value.forEach(function(obj) {
      if (typeof obj !== 'object') throw Error('Can\'t merge non-object values at ' + jsonpath);
      if (obj.$ref && (typeof obj.$ref === 'string')) {
        obj = jpointer.get(swagger, obj.$ref.substring(1));
      }
      if (!obj.properties) throw Error('Can\'t merge properties is undefiend ' + jsonpath);
      props = mergePatch.apply(props, obj.properties);
      required = required.concat(obj.required);
    });
    delete parent[name];
    Object.assign(parent.properties, props);
    let arr = parent.required.concat(required);
    Object.assign(parent.required, arr);
  },
  finish: function(swagger) {
    // TODO: cleanup unused $refs
  },
}
