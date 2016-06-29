

SparkleFormation.new(:jenkins, :provider => :azure).load(:base).overrides do

  dynamic!(:ubuntu,
           :jenkins,
           {
             :datadisksize => 40,
             :publicip => true,
             :adminpassword => "A96REykZdqWEAJ4H",
           }
          )

end
