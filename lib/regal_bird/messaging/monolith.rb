
def monolith(plans)
  
  # A channel is a connection to the rabbitmq backend; we create one here.
  ch = Channel.new
  
  # For each plan...
  plans.each do |plan|
    
    # Create a work exchange and a retry exchange. 
    wx = channel.topic("#{plan.name}-work", durable: true, auto_delete: false)
    rx = channel.headers("#{plan.name}-retry", durable: true, auto_delete: false)
    
    # For each source declared in the plan.,..
    plan.sources.each do |step, interval|
      # Create a work queue
      wq = ch.queue("source-#{normalize(step)}-work", src_work_queue_args())
        
      # And bind it to the work exchange on a route
      wq.bind(wx, routing_key: "source.#{normalize(step)}")
      
      # Create a retry queue
      rq = ch.queue("source-#{normalize(step)}-retry", src_retry_queue_args(wx.name, interval))
      
      # And bind it to the retry exchange on a different type of route       
      rq.bind(rx, arguments: { "source" => normalize(step) } )
      
      # Add a consumer to the work queue
      consumer = SourceConsumer.new(step, wx, rx) # The consumer needs the exchanges so it can publish to them
      wq.subscribe(consumer_tag: "#{wq.name}-#{wq.consumer_count + 1}", consumer.subscribe_args()) do |_info, _props, payload|
        consumer.perform(_info, _props, EventSerializer.deserialize(payload))
      end

      # Finally, send an initial message
      wx.publish(initial_message(wq.route, rq.route, initial_event(step)))
    end

    # For each action declared in the plan...
    plan.actions.each do |step, state, num_workers|

      # Create a work queue
      wq = ch.queue("action-#{normalize(step)}-#{state}-work", action_work_queue_args())

      # And bind it to the work exchange on a route
      wx.bind(wx, routing_key: "action.#{state}")

      # Create the desired number of consumers of the queue
      num_workers.times do
        consumer = ActionConsumer.new(step, wx, rx)
        wq.subscribe(consumer_tag: "#{wq.name}-#{wq.consumer_count + 1}", consumer.subscribe_args()) do |_info, _props, payload|
          consumer.perform(_info, _props, EventSerializer.deserialize(payload))
        end
      end
    end

  end
end


