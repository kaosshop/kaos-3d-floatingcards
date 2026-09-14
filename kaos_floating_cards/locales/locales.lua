Locales = {}

-- Missing keys fall back to English, so a partial translation is safe.
Locales.en = {
    lang = 'English',
    studio = 'Studio', floats = 'Floats', compose = 'Compose', style = 'Style',
    motion = 'Motion', place = 'Place', effects = 'Effects', rules = 'Rules',
    library = 'Library', ai = 'AI', settings = 'Settings', preview = 'Preview',
    newFloat = 'New float', import = 'Import', export = 'Export', save = 'Save',
    discard = 'Discard', delete = 'Delete', cancel = 'Cancel', close = 'Close',
    duplicate = 'Duplicate', search = 'Search', unsaved = 'unsaved', saved = 'saved',
    cardsVisible = 'Cards visible', cardsHidden = 'Cards hidden', live = 'Live',
    nothingSelected = 'Nothing selected', blocks = 'blocks', tall = 'tall',
    addBlock = 'Add block', collapseAll = 'Collapse all', insertEmoji = 'Insert emoji',
    text = 'Text', image = 'Image', icon = 'Icon', badge = 'Badge', divider = 'Divider',
    bar = 'Progress bar', keyHint = 'Key hint', row = 'Row',
    font = 'Font', size = 'Size', weight = 'Weight', letterSpacing = 'Letter spacing',
    colour = 'Colour', textStyle = 'Text style', align = 'Align', opacity = 'Opacity',
    plain = 'Plain', outline = 'Outline', glow = 'Glow', shadow = 'Shadow',
    uppercase = 'UPPERCASE', italic = 'Italic', tabular = 'Tabular numbers',
    background = 'Background', card = 'Card', padding = 'Padding', gap = 'Gap',
    accent = 'Accent', panel = 'Panel', radius = 'Radius', border = 'Border',
    outerGlow = 'Outer glow', innerHighlight = 'Inner highlight', speechTail = 'Speech tail',
    anchor = 'Anchor', worldPoint = 'World point', entity = 'Entity',
    vehiclePlate = 'Vehicle plate', me = 'Me', position = 'Position', offset = 'Offset',
    facing = 'Facing', faceCamera = 'Face the camera', upright = 'Upright',
    fixedAngle = 'Fixed angle', gizmo = 'Gizmo', move = 'Move', rotate = 'Rotate', off = 'Off',
    placeWithReticle = 'Place with the reticle', useMyPosition = 'Use my position',
    drawDistance = 'Draw distance', fadeBand = 'Fade band', hideCloser = 'Hide closer than',
    hideBehindWalls = 'Hide behind walls', jobs = 'Jobs', groups = 'Groups',
    hours = 'Hours', from = 'From', to = 'To', interaction = 'Interaction',
    lightBeam = 'Light beam', groundRing = 'Ground ring', tetherLine = 'Tether line',
    groundShadow = 'Ground shadow', height = 'Height', speed = 'Speed',
    bob = 'Bob', pulse = 'Pulse', sway = 'Sway', spin = 'Spin', orbit = 'Orbit',
    flicker = 'Flicker', appear = 'Appear', on = 'On',
    generateWithAi = 'Generate with AI', yourDescription = 'Your description',
    generate = 'Generate', thinking = 'Thinking...', tryOneOfThese = 'Try one of these',
    addAsNewFloat = 'Add as a new float', useOnSelected = 'Use on the selected float',
    themes = 'Themes', colours = 'Colours', interface = 'Interface', camera = 'Camera',
    layout = 'Layout', restoreDefaults = 'Restore defaults', language = 'Language',
    noAccess = 'You are not allowed to edit floats.',
    savedOk = 'Float saved.', deletedOk = 'Float deleted.',
    aiDisabled = 'AI generation is off. Add a Gemini key in config.lua.',
    aiFailed = 'The assistant could not build that card. Try again.',
}

Locales.pt = {
    lang = 'Português', floats = 'Cartões', compose = 'Compor', style = 'Estilo',
    motion = 'Movimento', place = 'Posição', effects = 'Efeitos', rules = 'Regras',
    library = 'Biblioteca', settings = 'Definições', preview = 'Pré-visualização',
    newFloat = 'Novo cartão', save = 'Guardar', discard = 'Descartar', delete = 'Apagar',
    cancel = 'Cancelar', close = 'Fechar', duplicate = 'Duplicar', search = 'Procurar',
    unsaved = 'não guardado', cardsVisible = 'Cartões visíveis', nothingSelected = 'Nada selecionado',
    addBlock = 'Adicionar bloco', text = 'Texto', image = 'Imagem', icon = 'Ícone',
    font = 'Tipo de letra', size = 'Tamanho', colour = 'Cor', align = 'Alinhar',
    background = 'Fundo', anchor = 'Âncora', position = 'Posição', facing = 'Orientação',
    drawDistance = 'Distância de desenho', jobs = 'Empregos', groups = 'Grupos',
    hours = 'Horas', generateWithAi = 'Gerar com IA', thinking = 'A pensar...',
    noAccess = 'Não tens permissão para editar cartões.',
}

Locales['pt-br'] = {
    lang = 'Português (BR)', floats = 'Cards', compose = 'Compor', style = 'Estilo',
    motion = 'Movimento', place = 'Posição', effects = 'Efeitos', rules = 'Regras',
    library = 'Biblioteca', settings = 'Configurações', preview = 'Prévia',
    newFloat = 'Novo card', save = 'Salvar', discard = 'Descartar', delete = 'Excluir',
    cancel = 'Cancelar', close = 'Fechar', duplicate = 'Duplicar', search = 'Buscar',
    unsaved = 'não salvo', cardsVisible = 'Cards visíveis', nothingSelected = 'Nada selecionado',
    addBlock = 'Adicionar bloco', text = 'Texto', image = 'Imagem', icon = 'Ícone',
    font = 'Fonte', size = 'Tamanho', colour = 'Cor', align = 'Alinhar',
    background = 'Fundo', anchor = 'Âncora', position = 'Posição', facing = 'Direção',
    drawDistance = 'Distância de exibição', jobs = 'Empregos', groups = 'Grupos',
    hours = 'Horário', generateWithAi = 'Gerar com IA', thinking = 'Pensando...',
    noAccess = 'Você não tem permissão para editar cards.',
}

Locales.es = {
    lang = 'Español', floats = 'Tarjetas', compose = 'Componer', style = 'Estilo',
    motion = 'Movimiento', place = 'Posición', effects = 'Efectos', rules = 'Reglas',
    library = 'Biblioteca', settings = 'Ajustes', preview = 'Vista previa',
    newFloat = 'Nueva tarjeta', save = 'Guardar', discard = 'Descartar', delete = 'Eliminar',
    cancel = 'Cancelar', close = 'Cerrar', duplicate = 'Duplicar', search = 'Buscar',
    unsaved = 'sin guardar', cardsVisible = 'Tarjetas visibles', nothingSelected = 'Nada seleccionado',
    addBlock = 'Añadir bloque', text = 'Texto', image = 'Imagen', icon = 'Icono',
    font = 'Fuente', size = 'Tamaño', colour = 'Color', align = 'Alinear',
    background = 'Fondo', anchor = 'Anclaje', position = 'Posición', facing = 'Orientación',
    drawDistance = 'Distancia de dibujo', jobs = 'Trabajos', groups = 'Grupos',
    hours = 'Horas', generateWithAi = 'Generar con IA', thinking = 'Pensando...',
    noAccess = 'No tienes permiso para editar tarjetas.',
}

Locales.fr = {
    lang = 'Français', floats = 'Cartes', compose = 'Composer', style = 'Style',
    motion = 'Mouvement', place = 'Placement', effects = 'Effets', rules = 'Règles',
    library = 'Bibliothèque', settings = 'Paramètres', preview = 'Aperçu',
    newFloat = 'Nouvelle carte', save = 'Enregistrer', discard = 'Annuler', delete = 'Supprimer',
    cancel = 'Annuler', close = 'Fermer', duplicate = 'Dupliquer', search = 'Rechercher',
    unsaved = 'non enregistré', cardsVisible = 'Cartes visibles', nothingSelected = 'Rien de sélectionné',
    addBlock = 'Ajouter un bloc', text = 'Texte', image = 'Image', icon = 'Icône',
    font = 'Police', size = 'Taille', colour = 'Couleur', align = 'Aligner',
    background = 'Arrière-plan', anchor = 'Ancrage', position = 'Position', facing = 'Orientation',
    drawDistance = 'Distance d\'affichage', jobs = 'Métiers', groups = 'Groupes',
    hours = 'Heures', generateWithAi = 'Générer avec l\'IA', thinking = 'Réflexion...',
    noAccess = 'Vous n\'êtes pas autorisé à modifier les cartes.',
}

Locales.de = {
    lang = 'Deutsch', floats = 'Karten', compose = 'Aufbau', style = 'Stil',
    motion = 'Bewegung', place = 'Platzierung', effects = 'Effekte', rules = 'Regeln',
    library = 'Bibliothek', settings = 'Einstellungen', preview = 'Vorschau',
    newFloat = 'Neue Karte', save = 'Speichern', discard = 'Verwerfen', delete = 'Löschen',
    cancel = 'Abbrechen', close = 'Schließen', duplicate = 'Duplizieren', search = 'Suchen',
    unsaved = 'ungespeichert', cardsVisible = 'Karten sichtbar', nothingSelected = 'Nichts ausgewählt',
    addBlock = 'Block hinzufügen', text = 'Text', image = 'Bild', icon = 'Symbol',
    font = 'Schrift', size = 'Größe', colour = 'Farbe', align = 'Ausrichten',
    background = 'Hintergrund', anchor = 'Anker', position = 'Position', facing = 'Ausrichtung',
    drawDistance = 'Sichtweite', jobs = 'Jobs', groups = 'Gruppen',
    hours = 'Uhrzeit', generateWithAi = 'Mit KI erzeugen', thinking = 'Denkt nach...',
    noAccess = 'Du darfst keine Karten bearbeiten.',
}

Locales.it = {
    lang = 'Italiano', floats = 'Schede', compose = 'Componi', style = 'Stile',
    motion = 'Movimento', place = 'Posizione', effects = 'Effetti', rules = 'Regole',
    library = 'Libreria', settings = 'Impostazioni', preview = 'Anteprima',
    newFloat = 'Nuova scheda', save = 'Salva', discard = 'Annulla', delete = 'Elimina',
    cancel = 'Annulla', close = 'Chiudi', duplicate = 'Duplica', search = 'Cerca',
    unsaved = 'non salvato', cardsVisible = 'Schede visibili', nothingSelected = 'Nessuna selezione',
    addBlock = 'Aggiungi blocco', text = 'Testo', image = 'Immagine', icon = 'Icona',
    font = 'Carattere', size = 'Dimensione', colour = 'Colore', align = 'Allinea',
    background = 'Sfondo', anchor = 'Ancoraggio', position = 'Posizione', facing = 'Orientamento',
    drawDistance = 'Distanza di disegno', jobs = 'Lavori', groups = 'Gruppi',
    hours = 'Ore', generateWithAi = 'Genera con IA', thinking = 'Sto pensando...',
    noAccess = 'Non puoi modificare le schede.',
}

Locales.nl = {
    lang = 'Nederlands', floats = 'Kaarten', compose = 'Opbouw', style = 'Stijl',
    motion = 'Beweging', place = 'Plaatsing', effects = 'Effecten', rules = 'Regels',
    library = 'Bibliotheek', settings = 'Instellingen', preview = 'Voorbeeld',
    newFloat = 'Nieuwe kaart', save = 'Opslaan', discard = 'Verwerpen', delete = 'Verwijderen',
    cancel = 'Annuleren', close = 'Sluiten', duplicate = 'Dupliceren', search = 'Zoeken',
    unsaved = 'niet opgeslagen', cardsVisible = 'Kaarten zichtbaar', nothingSelected = 'Niets geselecteerd',
    addBlock = 'Blok toevoegen', text = 'Tekst', image = 'Afbeelding', icon = 'Pictogram',
    font = 'Lettertype', size = 'Grootte', colour = 'Kleur', align = 'Uitlijnen',
    background = 'Achtergrond', anchor = 'Anker', position = 'Positie', facing = 'Richting',
    drawDistance = 'Tekenafstand', jobs = 'Banen', groups = 'Groepen',
    hours = 'Uren', generateWithAi = 'Genereren met AI', thinking = 'Denkt na...',
    noAccess = 'Je mag geen kaarten bewerken.',
}

Locales.pl = {
    lang = 'Polski', floats = 'Karty', compose = 'Kompozycja', style = 'Styl',
    motion = 'Ruch', place = 'Umiejscowienie', effects = 'Efekty', rules = 'Zasady',
    library = 'Biblioteka', settings = 'Ustawienia', preview = 'Podgląd',
    newFloat = 'Nowa karta', save = 'Zapisz', discard = 'Odrzuć', delete = 'Usuń',
    cancel = 'Anuluj', close = 'Zamknij', duplicate = 'Duplikuj', search = 'Szukaj',
    unsaved = 'niezapisane', cardsVisible = 'Karty widoczne', nothingSelected = 'Nic nie wybrano',
    addBlock = 'Dodaj blok', text = 'Tekst', image = 'Obraz', icon = 'Ikona',
    font = 'Czcionka', size = 'Rozmiar', colour = 'Kolor', align = 'Wyrównanie',
    background = 'Tło', anchor = 'Kotwica', position = 'Pozycja', facing = 'Zwrot',
    drawDistance = 'Zasięg rysowania', jobs = 'Prace', groups = 'Grupy',
    hours = 'Godziny', generateWithAi = 'Generuj z AI', thinking = 'Myślę...',
    noAccess = 'Nie masz uprawnień do edycji kart.',
}

Locales.cs = {
    lang = 'Čeština', floats = 'Karty', compose = 'Složení', style = 'Styl',
    motion = 'Pohyb', place = 'Umístění', effects = 'Efekty', rules = 'Pravidla',
    library = 'Knihovna', settings = 'Nastavení', preview = 'Náhled',
    newFloat = 'Nová karta', save = 'Uložit', discard = 'Zahodit', delete = 'Smazat',
    cancel = 'Zrušit', close = 'Zavřít', duplicate = 'Duplikovat', search = 'Hledat',
    unsaved = 'neuloženo', cardsVisible = 'Karty viditelné', nothingSelected = 'Nic nevybráno',
    addBlock = 'Přidat blok', text = 'Text', image = 'Obrázek', icon = 'Ikona',
    font = 'Písmo', size = 'Velikost', colour = 'Barva', align = 'Zarovnat',
    background = 'Pozadí', anchor = 'Ukotvení', position = 'Pozice', facing = 'Natočení',
    drawDistance = 'Dohlednost', jobs = 'Práce', groups = 'Skupiny',
    hours = 'Hodiny', generateWithAi = 'Vytvořit s AI', thinking = 'Přemýšlím...',
    noAccess = 'Nemáš oprávnění upravovat karty.',
}

Locales.tr = {
    lang = 'Türkçe', floats = 'Kartlar', compose = 'Oluştur', style = 'Stil',
    motion = 'Hareket', place = 'Konum', effects = 'Efektler', rules = 'Kurallar',
    library = 'Kütüphane', settings = 'Ayarlar', preview = 'Önizleme',
    newFloat = 'Yeni kart', save = 'Kaydet', discard = 'Vazgeç', delete = 'Sil',
    cancel = 'İptal', close = 'Kapat', duplicate = 'Çoğalt', search = 'Ara',
    unsaved = 'kaydedilmedi', cardsVisible = 'Kartlar görünür', nothingSelected = 'Seçim yok',
    addBlock = 'Blok ekle', text = 'Metin', image = 'Görsel', icon = 'Simge',
    font = 'Yazı tipi', size = 'Boyut', colour = 'Renk', align = 'Hizala',
    background = 'Arka plan', anchor = 'Bağlantı', position = 'Konum', facing = 'Yön',
    drawDistance = 'Çizim mesafesi', jobs = 'Meslekler', groups = 'Gruplar',
    hours = 'Saatler', generateWithAi = 'Yapay zekâ ile üret', thinking = 'Düşünüyor...',
    noAccess = 'Kartları düzenleme iznin yok.',
}

function Kaos.T(locale, key)
    local pack = Locales[locale] or Locales.en
    return pack[key] or Locales.en[key] or key
end
