dir = File.expand_path(File.dirname(__FILE__))
require dir + "/../lib/damerau_levenshtein_c"

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

describe 'DamerauLevenstein' do
  before(:all) do
    @dl = DamerauLevenshtein.new
  end
  
  it 'should get tests' do
    read_test_file do |y|
      unless y[:comment]
        if y[:block_size] < 3
          puts "%s, %s, %s" % [y[:str1], y[:str2], y[:distance]]
          @dl.distance(y[:str1], y[:str2], y[:block_size], y[:max_dist]).should == y[:distance]
        end
      end
    end
  end
end