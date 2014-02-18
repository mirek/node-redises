(function() {
  var Pool;

  Pool = (function() {
    function Pool(options) {
      if (options == null) {
        options = {};
      }
      this.objects = [];
      this.factory = options.factory;
      this.min = options.min;
      this.max = options.max;
    }

    Pool.prototype.enqueue = function(object) {
      return this.objects.push(object);
    };

    Pool.prototype.dequeue = function(f) {
      if (this.objects.length === 0) {
        return f(this.factory());
      } else {
        return f(this.objects.pop());
      }
    };

    return Pool;

  })();

  module.exports.Pool = Pool;

}).call(this);
