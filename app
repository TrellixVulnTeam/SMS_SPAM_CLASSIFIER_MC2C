import streamlit as st
import pickle
import string
from nltk.corpus import stopwords
import nltk
from nltk.stem.porter import PorterStemmer
ps = PorterStemmer()

def transform_text(text):
    text = text.lower()
    text = nltk.word_tokenize(text)

    y = []
    for i in text:
        if i.isalnum():
            y.append(i)

    text = y[:]  # cloning the list
    y.clear()

    for i in text:
        if i not in stopwords.words('english') and i not in string.punctuation:
            y.append(i)

    text = y[:]  # cloning the list
    y.clear()

    for i in text:
        y.append(ps.stem(i))

    return " ".join(y)

tfidf = pickle.load(open('','rb'))
model = pickle.load(open('','rb'))

st.title('Email/SMS Spam Classifier')

input_sms = st.text_input("Enter the message")

#1. preprocess
transform_sms = transform_text(input_sms)
#2. vectoorize
vector_input = tfidf.transform([transform_sms])
#3. predict
result = model.predict(vector_input)[0]
#4. display
if result == 1:
    st.header("Spam")
else:
    st.header("Ham")