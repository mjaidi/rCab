import places from 'places.js';

const initAutocomplete = () => {
  const start_address = document.getElementById('course_start_address');
  if (start_address) {
    places({ container: start_address });
  }
  const end_address = document.getElementById('course_end_address');
  if (end_address) {
    places({ container: end_address });
  }
};

export { initAutocomplete };
