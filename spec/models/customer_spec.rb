require 'rails_helper'

RSpec.describe Customer do
  subject { described_class.new(name: Faker::Company.name) }

  it 'is string' do
    expect(subject.name).to be_a(String)
  end

  it 'is Customer' do
    expect(subject).to be_a(described_class)
  end

  it 'is not null' do
    expect(subject).not_to be_nil
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'name is not empty' do
    expect(subject.name).not_to be_empty
  end

  it 'is a new customer and persisted' do
    expect(subject).to be_a_new(described_class)
  end
end
