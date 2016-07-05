def evaluate_fitness string
  string_copy = String.new string
  not_in_string = String.new @goal
  same_pos = 0
  string.each_char do |chr|
     index = string_copy.index chr
     same_pos += 1 if @goal[index] == chr
     not_in_string.sub! chr, ""
     string_copy[index] = 0.chr
  end
  fitness = 0
  fitness += (@goal.length - string.length).abs * 100
  fitness += (@goal.length - same_pos) * 250
  fitness += not_in_string.length * 100
  fitness += (string_copy.sum - not_in_string.sum).abs
  return fitness
end

def evolution number_of_children
  population_size = @population.length
  @population.map {|po| po[1] += 1}
  generate_children number_of_children
  @population.sort!
  @population = @population.shift population_size
end

def generate_char
  return (rand(95) + 32).chr
end

def generate_children n
  total_fitness = @population.map{|po| po[0]}.inject {|f1,f2| f1 + f2}
  parents = []
  children = []
  @population.each do |po|
    100 - 1.0*po[0]/total_fitness*100.times do parents << po end
  end
  n.times do
    parent1 = parents.sample
    parent2 = parents.sample
    gene = recombine parent1[2], parent2[2]
    mutate gene
    child = evaluate_fitness(gene), 0, gene
    @population << child
  end
end

def mutate string
  string.insert rand(string.length+1), generate_char if rand(2) == 1
  string.slice! rand(string.length) if rand(2) == 1
  char = string[rand(string.length)]
  string[rand(string.length)] = char if char and rand(2) == 1
end

def recombine string1, string2
  left  = rand(2) + 1
  right = rand(2) + 1
  return eval "string#{left}.slice(0..string#{left}.length/2-1) + string#{right}.slice(string#{right}.length/2..-1)"
end
@goal = "Pascal ist behindert!!!!1111elf"
counter = 0
@population = Array.new(25,[evaluate_fitness(''), 0, ''])
while @population.first.first != 0
  evolution 50
  counter += 1
  p [counter, @population.first[2], @population.first[0]].join ' - '
end
p "evolution step #{counter} - last generation:"
@population.each do |pheno|
  p "'#{pheno[2]}' - fitness: #{pheno[0]}"
end
