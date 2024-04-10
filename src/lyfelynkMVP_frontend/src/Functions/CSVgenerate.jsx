import { Button } from '@/components/ui/button';
import React, { useState } from 'react';

export function CSVgenerate() {
  const [data, setData] = useState(null);

  // Function to call the Cloud Function
  const callCloudFunction = async () => {
    try {
      const response = await fetch('https://us-central1-document-416209.cloudfunctions.net/function-1');
      const csvData = await response.text(); // Read response as text
      setData(csvData);
    } catch (error) {
      console.error('Error calling Cloud Function:', error);
    }
  };

  return (
    <div>
      <Button onClick={callCloudFunction}>Call Cloud Function</Button>
      {data && (
        <div>
          <p>Response from Cloud Function:</p>
          <pre>{data}</pre> {/* Display CSV data */}
        </div>
      )}
    </div>
  );
}







