(function() {
  var Pool;

  Pool = (function() {
    function Pool(options) {
      if (options == null) {
        options = {};
      }
      this.outside = [];
      this.inside = [];
      this.decorators = [];
      this.factory = options.factory;
    }

    Pool.prototype.count = function() {
      return this.inside.length + this.outside.length;
    };

    Pool.prototype.insideCount = function() {
      return this.inside.length;
    };

    Pool.prototype.outsideCount = function() {
      return this.outside.length;
    };

    Pool.prototype.each = function(f) {
      var object, _i, _j, _len, _len1, _ref, _ref1, _results;
      _ref = this.inside;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        object = _ref[_i];
        f(object);
      }
      _ref1 = this.outside;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        object = _ref1[_j];
        _results.push(f(object));
      }
      return _results;
    };

    Pool.prototype.decorate = function(decorator, done) {
      var eachDone, i;
      if (done == null) {
        done = null;
      }
      this.decorators.push(decorator);
      i = this.count();
      eachDone = function() {
        if (--i === 0) {
          if (done != null) {
            return done();
          }
        }
      };
      return this.each(function(object) {
        return decorator(object, function() {
          return eachDone();
        });
      });
    };

    Pool.prototype.decorateObject = function(object, i, done) {
      if (i < this.decorators.length) {
        return this.decorateObject(object, i + 1, done);
      } else {
        return done();
      }
    };

    Pool.prototype.create = function(done) {
      return this.factory((function(_this) {
        return function(object) {
          return _this.decorateObject(object, 0, function() {
            return done(object);
          });
        };
      })(this));
    };

    Pool.prototype.enqueue = function(object) {
      this.outside.splice(this.outside.indexOf(object), 1);
      return this.inside.push(object);
    };

    Pool.prototype.dequeue = function(done) {
      var object;
      if (this.inside.length > 0) {
        object = this.inside.pop();
        this.outside.push(object);
        return done(object);
      } else {
        return this.create((function(_this) {
          return function(object) {
            _this.outside.push(object);
            return done(object);
          };
        })(this));
      }
    };

    return Pool;

  })();

  module.exports.Pool = Pool;

}).call(this);
