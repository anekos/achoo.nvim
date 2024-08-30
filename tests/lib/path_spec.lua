local assert = require('luassert')
local Path = require('achoo.lib.path')

describe('lib.path.relative_path', function()
  local rp = Path.relative_path

  it('Same path', function()
    assert.equals(rp('/home/achoo/foo/bar', '/home/achoo/foo/bar'), '.')

    assert.equals(rp('/home/achoo/foo/bar/', '/home/achoo/foo/bar'), '.')

    assert.equals(rp('/home/achoo/foo/bar', '/home/achoo/foo/bar/'), '.')
  end)

  it('In sub directory', function()
    assert.equals(rp('/home/achoo/foo/bar', '/home/achoo/foo'), 'bar')
    assert.equals(rp('/home/achoo/foo/bar/', '/home/achoo/foo'), 'bar')
    assert.equals(rp('/home/achoo/foo/bar/', '/home/achoo/foo/'), 'bar')
    assert.equals(rp('/home/achoo/foo/bar', '/home/achoo/foo/'), 'bar')
  end)

  it('In parent directory', function()
    assert.equals(rp('/home/achoo/foo', '/home/achoo/foo/bar'), '/home/achoo/foo')
  end)
end)
