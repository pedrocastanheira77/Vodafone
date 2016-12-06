require_relative "vglobais.rb"
require_relative "vsites.rb"
require_relative "vsitesmes.rb"
require_relative "vsitestrimestre.rb"
require_relative "vtarifas.rb"
require_relative "vtarifasmes.rb"
require_relative "vreport_cap2.rb"
require_relative "vreport_cap3.rb"
require_relative "vreport_cap3a.rb"
require_relative "vreport_cap4.rb"
require_relative "vreport_cap7.1_e_2.rb"
require_relative "vreport_cap7.3.rb"
require_relative "vreport_cap7.4.rb"
require_relative "vreport_cap7.5.rb"
#require_relative "vfuncoes.rb"

system "cls"
lineWidth = 15

puts "Preparando ficheiros".ljust(lineWidth)
ficheiroswm = corre_vfiles
puts "Terminado!".ljust(lineWidth)
puts

puts "Geracao de ficheiros de consumos globais".ljust(lineWidth)
corre_vglobais(ficheiroswm)
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando ficheiros de consumo por site".ljust(lineWidth)
corre_vsites
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando ficheiros de consumo mensais por site".ljust(lineWidth)
corre_vsitesmes
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando ficheiros de custos trimestrais por site".ljust(lineWidth)
corre_vsitestrimestre
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando ficheiros de custos por site".ljust(lineWidth)
corre_vtarifas
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando ficheiros de custos mensais por site".ljust(lineWidth)
corre_vtarifasmes
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabelas para Capitulo 2...".ljust(lineWidth)
corre_vcap_2
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabelas para Capitulo 3...".ljust(lineWidth)
corre_vcap_3
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabelas para Capitulo 3...".ljust(lineWidth)
corre_vcap_3a
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabelas para Capitulo 4...".ljust(lineWidth)
corre_vcap_4
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabela para Capitulo 7.1 e 7.2...".ljust(lineWidth)
corre_vcap_71_72
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabela para Capitulo 7.3...".ljust(lineWidth)
corre_vcap_73
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabela para Capitulo 7.4...".ljust(lineWidth)
corre_vcap_74_consumo_energia
puts "Terminado!".ljust(lineWidth)
puts

puts "Preparando tabela para Capitulo 7.5...".ljust(lineWidth)
corre_vcap_75_consumo_energia_por_tensao
puts "Terminado!".ljust(lineWidth)
puts
