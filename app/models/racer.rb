# Racer model class which integrates with MongoDB
class Racer
  include Mongoid::Document
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    mongo_client[:racers]
  end

  def self.all(prototype = {}, sort = { number: 1 }, skip = 0, limit = nil)
    if limit
      collection.find(prototype).skip(skip).sort(sort).limit(limit)
    else
      collection.find(prototype).skip(skip).sort(sort)
    end
  end

  def initialize(params = {})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
  end

  def self.find(id)
    result = collection.find(_id: id).first ||
             collection.find(_id: BSON::ObjectId.from_string(id)).first
    result.nil? ? nil : Racer.new(result)
  end

  def save
    result = collection.insert_one(number: @number,
                                   first_name: @first_name,
                                   last_name: @last_name,
                                   gender: @gender,
                                   group: @group,
                                   secs: @secs)
    @id = result.inserted_id.to_s
  end

  def update(params)
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i

    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs)
    collection.find(_id: BSON::ObjectId.from_string(@id)).update_one(params)
  end

  def destroy
    collection.find(_id: BSON::ObjectId.from_string(@id)).delete_one
  end

  def persisted?
    !@id.nil?
  end

  def created_at
    nil
  end
  
  def updated_at
    nil
  end
end
