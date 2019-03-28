var jpointer = require('json-pointer');
var mergePatch = require('json-merge-patch');

module.exports = {
  pathExpression: '$..["x-merge-properties"]',
  init: function(swagger) {
    console.log('* x-merge-properties plugin');
  },
  process: function(parent, name, jsonpath, swagger) {
    var value = parent[name];
    if (!Array.isArray(value)) {
      throw Error('x-merge-properties argument should be array at ' + jsonpath);
    }
    let required = [];
    let properties = {};
    value.forEach(function(obj) {
      if (obj.$ref && (typeof obj.$ref === 'string')) {
        obj = jpointer.get(swagger, obj.$ref.substring(1));
      }
      if (typeof obj !== 'object') throw Error('Can\'t merge non-object values at ' + jsonpath);
      required = required.concat(obj.required || []);
      properties = mergePatch.apply(properties, obj.properties || {});
    });
    delete parent[name];
    parent.required = required;
    parent.properties = properties;
  },
  finish: function(swagger) {
    // TODO: cleanup unused $refs
  },
}