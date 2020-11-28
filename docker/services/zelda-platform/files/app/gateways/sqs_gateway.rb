# SQS Gateway
class SqsGateway
  # 初期化
  #
  # @param [Hash] args 引数
  # @option args [Hash] :client_options SQS Client オプション
  def initialize(args = {})
    return
    @client_options = args[:client_options] || {}
  end

  # Creates a new standard or FIFO queue or returns the URL of an existing queue.
  #
  # @param [String] queue_name
  # @param [Hash] attributes
  # @return [String] queue_url
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html#create_queue-instance_method
  def create_queue(queue_name, attributes = {})
    return
    client.create_queue(queue_name: queue_name, attributes: attributes).try(:queue_url)
  end

  # Returns the URL of an existing queue.
  #
  # @param [String] queue_name
  # @return [String] queue_url
  def get_queue_url(queue_name)
    return
    client.get_queue_url(queue_name: queue_name).try(:queue_url)
  end

  # Delivers a message to the specified queue.
  #
  # @param [String] queue_url
  # @param [String] message_body
  # @param [Hash] options
  # @option options [Integer] :delay_seconds
  # @option options [Hash] :message_attributes
  # @option options [String] :message_deduplication_id
  # @option options [String] :message_group_id
  # @return [Aws::SQS::Types::SendMessageResult]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html#send_message-instance_method
  def send_message(queue_url, message_body, options = {})
    return
    client.send_message({ queue_url: queue_url, message_body: message_body }.merge(options))
  end

  # Delivers a message to the specified queue name(no check).
  #
  # @param [String] queue_name
  # @param [String] message_body
  # @param [Hash] options
  # @option options [Integer] :delay_seconds
  # @option options [Hash] :message_attributes
  # @option options [String] :message_deduplication_id
  # @option options [String] :message_group_id
  # @return [Aws::SQS::Types::SendMessageResult]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html#send_message-instance_method
  def send_message_with_queue_name(queue_name, message_body, options = {})
    return
    queue_url = get_queue_url(queue_name)
    send_message(queue_url, message_body, options)
  end

  # Retrieves one or more messages (up to 10), from the specified queue.
  #
  # @param [String] queue_url
  # @param [Hash] options
  # @option options [Array<String>] :attribute_names
  # @option options [Array<String>]:message_attribute_names
  # @option options [Integer] :max_number_of_messages
  # @option options [Integer] :visibility_timeout
  # @option options [Integer] :wait_time_seconds
  # @option options [String] :receive_request_attempt_id
  # @return [Array<String>] messages
  # @see http://docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html#receive_message-instance_method
  def receive_message(queue_url, options = {})
    return
    client.receive_message({ queue_url: queue_url }.merge(options)).try(:messages)
  end

  # Gets attributes for the specified queue.
  #
  # @param [String] queue_url
  # @param [Hash] options
  # @option options [Array<String>] :attribute_names
  # @see http://docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html#get_queue_attributes-instance_method
  def get_queue_attributes(queue_url, options = {})
    return
    attribute_names = options['attribute_names'] || ['All']
    client.get_queue_attributes(queue_url: queue_url, attribute_names: attribute_names).try(:attributes)
  end

  private

  # AWS SQS Clientインスタンス生成
  #
  # @return [Aws::SQS::Client]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html
  def client
    return
    @client ||= Aws::SQS::Client.new(@client_options)
  end
end
