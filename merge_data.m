load('paso1_faces.mat')

f_features = features;
f_features_labels = features_labels;

persona_expected = persona;
foto_expected = foto;

load('paso1_patches.mat')

features = [features, f_features(valid_indexes,:)];
features_labels = [features_labels; f_features_labels];

 if (nnz(persona ~= persona_expected(valid_indexes)) > 0) || (nnz(foto ~= foto_expected(valid_indexes)) > 0)
  error('Unexpected ids mismatch!');
 else
  save('paso1.mat', 'features','features_labels','persona','foto', 'valid_indexes');
end