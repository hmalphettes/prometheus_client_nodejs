debug   = require("debug")("prometheus-client:metric")
hash    = require "object-hash"

module.exports = class BaseMetric
    # Valid opts are namespace, subsystem, name, help and labels.
    constructor: (opts) ->
        @name           = opts?.name
        @namespace      = opts?.namespace
        @subsystem      = opts?.subsystem
        @help           = opts?.help
        @base_labels    = opts?.labels

        # Init an empty values object, which will be keyed with labels.
        @_values        = new Map()

        # Also init an empty object for caching hashed labels.
        @_labelCache    = new Map()
        @_labelKeys     = null

        throw "Name is required" if !@name
        throw "Help is required" if !@help

        @_full_name     = [ @namespace, @subsystem, @name ].filter((s)->s).join("_")

    #----------

    type: ->
        throw "Metrics must set a type"

    #----------

    default: ->
        null

    #----------

    get: (labels={}) ->
        lh = @label_hash_for(labels)
        @_values.has(lh) || @default()

    #----------

    values: ->
        values = []
        lc = @_labelCache

        # once coffeescript support the spread operator:
        #uneval([...@_values]).map((kv)->kv[0]=lc.get(lh);kv)
        @_values.forEach (v,lh)->values.push([lc.get(lh), v])

        values

    #----------

    label_hash_for: (labels) ->
        lh = hash.sha1(labels)

        return lh if @_labelCache.has(lh)

        # Validate each label key
        for k,v of labels
            throw "Label #{k} must not start with __" if /^__/.test(k)
            throw "Label #{k} is reserved" if 'instance'==k || 'job'==k

        # Validate that the set of keys is correct
        if @_labelKeys && hash.keys(labels) != @_labelKeys
            throw "Labels must have the same signature"

        # If yes to both, stash
        @_labelKeys = hash.keys(labels) if !@_labelKeys
        @_labelCache.set(lh, labels)

        lh
