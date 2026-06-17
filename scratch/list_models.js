const apiKey = 'AIzaSyCCVa0_GMRsZ4Gx64Nt5gn5vRLRZRC9lwI';
const url = `https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey}`;

fetch(url)
.then(res => res.json().then(data => console.log("Status:", res.status, JSON.stringify(data, null, 2))))
.catch(err => console.error(err));
