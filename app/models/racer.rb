class Racer
  include Mongoid::Document
  
  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs
   
  def self.mongo_client
    Mongoid::Clients.default
  end
  
  def self.collection
    self.mongo_client[:racers]
  end
  
  def self.all(prototype={}, sort={:number=>1}, skip=0, limit=nil)
    if (limit)
      self.collection.find(prototype).skip(skip).sort(sort).limit(limit)
    else
      self.collection.find(prototype).skip(skip).sort(sort)
   end
  end
end

