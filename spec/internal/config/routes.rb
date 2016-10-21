Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs'
end
