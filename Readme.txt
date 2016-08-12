Introduction:

This package provides a Matlab implementation of Conditional Tree-structured Bayesian Networks [Batal, Hong, Hauskrecht 2013] that builds structured prediction models for multi-label classification.

To train a model, use CTBN/learn_output_tree_sw.m. To use a trained model for prediction, use CTBN/MAP_prediction_sw.m.

demo.m contains a demonstration script that learns and uses the CTBN models on the emotions dataset [Trohidis et al. 2008].

The package has been written and tested on Matlab R2012a-R2013a.


----

Disclaimer:

This code package can be used for academic purposes only. We do not guarantee that the code is correct, current or complete, and do not provide any technical support. Accordingly, the users are advised to confirm the correctness of the package before making any decisions with it.


----

Reference:

[Batal, Hong, Hauskrecht 2013] I. Batal, C. Hong, M. Hauskrecht. An efficient probabilistic framework for multi-dimensional classification. ACM International Conference on Information and Knowledge Management (CIKM 2013), Burlingame, CA, USA. October 2013.

[Fan et al. 2008] R. Fan, K. Chang, C. Hsieh, X. Wang, and C. Lin. LIBLINEAR: A Library for Large Linear Classification, Journal of Machine Learning Research 9(2008), 1871-1874. Software available at http://www.csie.ntu.edu.tw/~cjlin/liblinear

[Trohidis et al. 2008] K. Trohidis, G. Tsoumakas, G. Kalliris, I. Vlahavas. "Multilabel Classification of Music into Emotions". Proc. 2008 International Conference on Music Information Retrieval (ISMIR 2008), Philadelphia, PA, USA, 2008.
