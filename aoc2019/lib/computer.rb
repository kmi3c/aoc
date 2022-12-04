class Computer
  COUNTER = 4

  def initialize(input)
    @ints = input
  end

  def execute(array)
    # puts array.to_s
    # Execute optcode array[0] integer as 1 = sum, 2 multiple
    # on elements on position in @ints stored it array[1] and array[2] and
    # store thid result to @ints position stored in array[3]
    c = @ints[array[1]].send(command(array[0]), @ints[array[2]])
    # puts "#{@ints[array[1]]}#{command(array[0])}#{@ints[array[2]]} == #{c}"
    # puts "append position: #{array[3]} [#{@ints[array[3]]} = #{c}]"
    @ints[array[3]] = c
  end

  def command(code)
    %i[== + *][code]
  end

  def process
    o_pointer = 0
    opcode = 0
    while opcode != 99
      opcode = @ints[o_pointer]
      # puts "Opcode: #{opcode}"
      if opcode != 99
        execute(@ints[o_pointer..o_pointer + COUNTER - 1])
        o_pointer += COUNTER unless opcode == 99
      end
    end
    @ints[0]
  end

  def result
    @ints[0]
  end
end
