dir = File.expand_path(File.dirname(__FILE__))
require dir + "/../lib/damerau_levenshtein_mod"
require dir + "/../lib/tony_rees"

def read_test_file
  f = open(File.expand_path(File.dirname(__FILE__)) + '/test.txt')
  f.each do |line|
    str1, str2, max_dist, block_size, distance = line.split("|")
    if line.match(/^\s*#/) == nil && str1 && str2 && max_dist && block_size && distance
      distance = distance.split('#')[0].strip
      distance = (distance == 'null') ? nil : distance.to_i
      yield({:str1 => str1, :str2 => str2, :max_dist => max_dist.to_i, :block_size => block_size.to_i, :distance => distance})
    else
      yield({:comment => line})
    end
  end
end

describe 'DamerauLevensteinMod' do
  it 'should get tests' do
    read_test_file do |y|
      dl = DamerauLevenshteinMod.new
      unless y[:comment]
        puts "%s, %s, %s" % [y[:str1], y[:str2], y[:distance]]
        dl.distance(y[:str1], y[:str2], y[:block_size], y[:max_dist]).should == y[:distance]
      end
    end
  end
end

describe 'Tony Rees mdld' do
  it 'should get tests' do
    trd = TonyRees.new
    read_test_file do |y|
      unless y[:comment]
        puts "%s, %s, %s" % [y[:str1], y[:str2], y[:distance]]
        trd.distance(y[:str1], y[:str2], y[:block_size],y[:max_dist]).should == y[:distance]        
      end
    end
  end
end