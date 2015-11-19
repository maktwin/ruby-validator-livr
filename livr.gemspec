# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "livr"

  s.version = "0.0.2"

  s.homepage = "https://github.com/maktwin/ruby-validator-livr"

  s.summary = "Validator LIVR"

  s.description = "Lightweight validator supporting Language Independent Rules Specification"

  s.license = "Artistic_2_0"

  s.authors = [
    "Viktor Turskyi",
    "Maksym Panchokha"
  ]

  s.email = ["m.panchoha@gmail.com"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~> 5.4"
  s.add_development_dependency "minitest-reporters", "~> 1.1"
end