(function() {
  var Pool;

  Pool = (function() {
    function Pool(options) {
      var factory, _ref;
      if (options == null) {
        options = {};
      }
      this.objects = [];
      this.decorators = [];
      if (options.factory != null) {
        factory = options.factory;
        this.decorators.push((function(object, done) {
          return factory(done);
        }));
      }
      this.min = (options.min != null) && +options.min >= 0 ? +options.min | 0 : 5;
      this.max = (options.max != null) && +options.max >= 0 ? +options.max | 0 : 128;
      if (this.min > this.max) {
        _ref = [this.max, this.min], this.min = _ref[0], this.max = _ref[1];
      }
    }

    Pool.prototype.length = function() {
      return this.objects.length;
    };

    Pool.prototype.each = function(f) {
      var object, _i, _len, _ref, _results;
      _ref = this.objects;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        object = _ref[_i];
        _results.push(f(object));
      }
      return _results;
    };

    Pool.prototype.enqueue = function(object) {
      return this.objects.push(object);
    };

    Pool.prototype.appendDecorator = function(f) {
      return this.decorators.push(f);
    };

    Pool.prototype.create = function(done, object, i) {
      if (object == null) {
        object = null;
      }
      if (i == null) {
        i = 0;
      }
      return this.decorators[i](object, (function(_this) {
        return function(decorated) {
          if (i + 1 < _this.decorators.length) {
            return _this.create(done, decorated, i + 1);
          } else {
            return done(decorated);
          }
        };
      })(this));
    };

    Pool.prototype.dequeue = function(done) {
      if (this.objects.length === 0) {
        return this.create(done);
      } else {
        return done(this.objects.pop());
      }
    };

    return Pool;

  })();

  module.exports.Pool = Pool;

}).call(this);
