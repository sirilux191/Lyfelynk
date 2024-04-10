import { Download } from 'lucide-react';
import React from 'react';

const DownloadFile = () => {
  const handleDownload = () => {
    // Dummy download function
    console.log('File downloaded!');
  };

  return (
      <button
        className=" p-2 text-white bg-primary rounded-lg"
        onClick={handleDownload}
      >
        <Download/>
      </button>
  );
};

export default DownloadFile;
