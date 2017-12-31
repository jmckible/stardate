import cable from 'actioncable';

let consumer;

createChannel = (...args) => {
  if (!consumer) {
    consumer = cable.createConsumer();
  }

  return consumer.subscriptions.create(...args);
};

export default createChannel;
