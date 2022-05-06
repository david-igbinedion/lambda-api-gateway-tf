// Lambda function code

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Hello, World from Ulesson!';

  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'Hello, ' + event.queryStringParameters['Name'] + '!';
  }
 
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}

module.exports.handler2 = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Learn with Ulesson!';

  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'What would you like to learn today ' + event.queryStringParameters['Name'] + '?';
  }
 
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}
