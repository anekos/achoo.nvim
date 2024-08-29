local P = require('achoo.postprocess')
local assert = require('luassert')

describe('postprocess.process', function()
  local validator = function(buffer_number)
    return buffer_number == 123
  end

  local p = function(buffer_number)
    return P.process(buffer_number, validator)
  end

  it('badd should be removed', function()
    assert.are.same(
      p {
        'foo',
        'bar',
      },
      {
        'foo',
        'bar',
      }
    )

    assert.are.same(
      p {
        'foo',
        'badd +16',
        'bar',
      },
      {
        'foo',
        'bar',
      }
    )
  end)
end)
