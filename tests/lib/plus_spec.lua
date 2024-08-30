local P = require('achoo.lib.plus')
local assert = require('luassert')

describe('lib.path.relative_path', function()
  local e = P.encode
  local d = P.decode

  it('Encode', function()
    assert.equals(e('foo-bar'), 'foo-bar')
    assert.equals(e('foo%bar'), 'foo+25bar')
  end)

  it('Decode', function()
    assert.equals(d('foo-bar'), 'foo-bar')
    assert.equals(d('foo+25bar'), 'foo%bar')
  end)
end)
