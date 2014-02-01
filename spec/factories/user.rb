FactoryGirl.define do
  factory :user do
    name "Joe Foo"
    password_hash "$2a$10$yFYTo5OgRbC9QPG.w1GvgucqTu.1C612Cwvx2x/FfOMtxFCRLZz.S"
    email "joe.foo@blarg.org"
  end
end