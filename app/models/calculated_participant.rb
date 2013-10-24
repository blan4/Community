class CalculatedParticipant
  include Mongoid::Document

  field :_id, type: String
  field :value, type: Hash

  def gravatar(size)
    size ||= 50
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(id)}?size=#{size}"
  end

  def self.recalculate
    map = %Q{
      function(){
        var value = {}
        this.participants.forEach(function(part){
          value.name = part.name;
          value.surname = part.surname;
          if (part.was == true){
            value.skip = 0;
            value.was = 1;
          } else {
            value.skip = 1;
            value.was = 0;
          }
          emit(part.email, value);
        });
      }
    }

    reduce = %Q{
      function(key, values){
        var value = {name: '', surname: '', was: 0, skip: 0, goodness: 0};
        values.forEach(function(val){
          value.name = val.name;
          value.surname = val.surname;
          value.categories = val.categories;
          value.was += val.was;
          value.skip += val.skip;
        });
        return value;
      }
    }

    finalize = %Q{
      function(key,value){
        var all = value.was + value.skip;
        if (all == 0){
          value.goodness = 0;
          return value;
        }
        value.goodness = value.was*value.was / all;
        return value;
      }
    }

    Event.map_reduce(map,reduce).out(replace: 'calculated_participants').finalize(finalize).to_a
  end
end
